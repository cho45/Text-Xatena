package Text::Xatena;

use strict;
use warnings;
use UNIVERSAL::require;

use Text::Xatena::LineScanner;
use Text::Xatena::Node;
use Text::Xatena::Node::Root;
use Text::Xatena::Inline;

our $VERSION = '0.04';

our $SYNTAXES = [
    'Text::Xatena::Node::SuperPre',
    'Text::Xatena::Node::StopP',
    'Text::Xatena::Node::Blockquote',
    'Text::Xatena::Node::Pre',
    'Text::Xatena::Node::List',
    'Text::Xatena::Node::DefinitionList',
    'Text::Xatena::Node::Table',
    'Text::Xatena::Node::Section',
    'Text::Xatena::Node::Comment',
];

sub new {
    my ($class, %opts) = @_;

    $opts{syntaxes} ||= $SYNTAXES;

    my $self = bless {
        %opts
    }, $class;

    for my $pkg (@{ $self->{syntaxes} }) {
        $pkg->use or die $@;
    }

    $self;
}

sub format {
    my ($self, $string, %opts) = @_;
    if ($opts{hatena_compatible} || $self->{hatena_compatible}) {
        $self->_format_hatena_compat($string, %opts);
    } else {
        $self->_format($string, %opts);
    }
}

sub _format {
    my ($self, $string, %opts) = @_;
    $opts{inline} ||= Text::Xatena::Inline->new;
    $self->_parse($string)->as_html(
        %opts
    );
}

sub _format_hatena_compat {
    my ($self, $string, %opts) = @_;

    no warnings "once", "redefine";
    local $Text::Xatena::Node::Section::BEGINNING = "";
    local $Text::Xatena::Node::Section::ENDOFNODE = "";
    local *Text::Xatena::Node::as_html_paragraph = sub {
        my ($self, $text, %opts) = @_;
        $text = $self->inline($text, %opts);

        $text =~ s{^\n}{}g;
        if ($opts{stopp}) {
            $text;
        } else {
            "<p>" . join("</p>\n<p><br /></p>\n<p>", map { join("</p>\n<p>", split /\n+/) } split(/\n\n\n/, $text)) . "</p>\n";
        }
    };

    $opts{inline} ||= Text::Xatena::Inline->new;
    $self->_parse($string)->as_html(
        %opts
    );
}

sub _parse {
    my ($self, $string) = @_;

    my @syntaxes = @{ $self->{syntaxes} };
    my $s        = Text::Xatena::LineScanner->new($string);
    my $root     = Text::Xatena::Node::Root->new ;
    my $stack    = [ $root ];
    loop: until ($s->eos) {
        my $parent = $stack->[-1];

        for my $pkg (@syntaxes) {
            $pkg->parse($s, $parent, $stack) and next loop;
        }

        # plain lines
        push @$parent, $s->next;
    }

    $root;
}

1;
__END__

=head1 NAME

Text::Xatena - Text-to-HTML converter with Xatena syntax.

=head1 SYNOPSIS

  use Text::Xatena;

  my $thx = Text::Xatena->new;
  $thx->format($string);

  # with some aggressive functions
  $thx->format($string,
      inline => Text::Xatena::Inline::Aggressive->new(cache => Cache::MemoryCache->new)
  );

Customizing inline formatting rule

  Text::Xatena->new->format($string,
      inline => MyInline->new
  );

  package MyInline;
  use strict;
  use warnings;
  use Text::Xatena::Inline::Base -Base;
  
  match qr{\@([a-z0-9]+)} => sub {
      my ($self, $twitter_id) = @_;
      sprintf('<a href="http://twitter.com/%s">@%s</a>',
          $twitter_id,
          $twitter_id,
      );
  };
  
  1;

=head1 DESCRIPTION

Text::Xatena is a text-to-html converter.

Text::Xatena is comfortably to writing usual diary and blog,
especially for programmers, writers treating long text.

=head2 What is Xatena

Xatena syntax is similar to Hatena syntax (implemented as L<Text::Hatena|Text::Hatena>),
but is independent from Hatena services and has more expandability.

Most block level syntax notations are supported and more compatibility with Hatena::Diary
than Text::Hatena 0.20.

And don't support rare syntax or what isn't to be done of syntax formatter. (eg. linking keywords)

=head1 SYNTAX

Basically, Xatena convert single line breaks to C<<br/>> and
double line breaks to C<<p>> element except "Stop P" syntax.

  fooo
  bar

  baz

is converted to following:

  <p>fooo<br/>bar</p>
  <p>baz</p>

=head2 Blockquote

  >>
  quoted text

  foobar
  <<

is converted to following:

  <blockquote>
  <p>quoted text</p>
  <p>foobar</p>
  </blockquote>

=head3 with cite

  >http://example.com/>
  foobar
  <<

is converted to following:

  <blockquote cite="http://example.com/">
    <p>quote</p>
    <cite><a href="http://example.com/">http://example.com/</a></cite>
  </blockquote>

=head2 Pre

  >|
  pre <a href="">formatted</a>
  |<

is converted to following:

  <pre>
  pre <a href="">formatted</a>
  </pre>

=head2 Super pre

  >||
  super pre <a>
  ||<

is converted to following:

  <pre>
  super pre &lt;a&gt;
  </pre>

=head3 with lang

  >|perl|
  use Text::Xatena;
  ||<

is converted to following:

  <pre class="code lang-perl">
  use Text::Xatena;
  </pre>

=head2 Stop P

Stop insert p or br.

  ><blockquote>
  <p>
  hogehoge br
  </p>
  </blockquote>< 

is converted to following:

  <blockquote>
  <p>
  hogehoge br
  </p>
  </blockquote><

=head3 with custom block level element

  ><ins><
  foobar
  ></ins><

is convert with auto inserting p to

  <ins>
  <p>foobar</p>
  </ins>

=head2 Section

Create structured sections by * following heading.

  * head1

  foobar

  ** head2

  *** head3

is converted to following: 

  <div class="section">
  <h3>head1</h3>
  <p>foobar</p>
    <div class="section">
    <h4>head2</h4>
      <div class="section">
      <h5>head3</h5>
      </div>
    </div>
  </div>

=head2 List

=head3 unordered list

  - ul
  - ul
  -- ul
  -- ul
  --- ul
  - ul

is converted to following:

  <ul>
    <li>ul</li>
    <li>ul</li>
    <li>
      <ul>
        <li>ul</li>
        <li>ul</li>
        <li>
          <ul>
            <li>ul</li>
          </ul>
        </li>
      </ul>
    </li>
    <li>ul</li>
  </ul>

=head3 ordered list

  + ol
  + ol
  ++ ol
  ++ ol
  +++ ol
  + ol

is converted to following:

  <ol>
    <li>ol</li>
    <li>ol</li>
    <li>
      <ol>
        <li>ol</li>
        <li>ol</li>
        <li>
          <ol>
            <li>ol</li>
          </ol>
        </li>
      </ol>
    </li>
    <li>ol</li>
  </ol>

=head3 mixed list

  - ul
  - ul
  -+ ol
  -+ ol
  -+ ol
  - ul

=head3 definition list

  :definition:description
  :definition:description

is converted to following:

  <dl>
    <dt>definition</dt>
    <dd>description</dd>
    <dt>definition</dt>
    <dd>description</dd>
  </dl>

=head4 multiline

This is incompatible syntax with Hatena::Diary

  :definition:
  :: description
  :definition:
  :: description

=head2 Table

  |*foo|*bar|*baz|
  |test|test|test|
  |test|test|test|

is converted to following:

  <table>
    <tr>
      <th>foo</th>
      <th>bar</th>
      <th>baz</th>
    </tr>
    <tr>
      <td>test</td>
      <td>test</td>
      <td>test</td>
    </tr>
    <tr>
      <td>test</td>
      <td>test</td>
      <td>test</td>
    </tr>
  </table>

=head2 Inline syntax

=over 2

=item Autolink http:// ftp:// mailto://

  http://example.com/
  ftp://example.com/
  mailto:cho45@lowreal.net
  [http://example.com/]

  # using Xatena::Inline::Aggressive
  [http://example.com/]
  [http://example.com/:title] # auto retrieving from url
  [http://example.com/:title=Foobar]
  [http://example.com/:barcode] # show qrcode with google chart API

=item Deter inline syntax

  []http://example.com/[]

=back

=head2 Compatibility with Hatena::Diary syntax

Some default behaviors of Xatena syntax are different from Hatena::Diary syntax.

Big differences:

=over 4

=item 1. Hatena::Diary syntax converts single break to C<<p>> block but Xatena converts it to C<<br/>>.

=item 2. Hatena::Diary syntax converts * (heading notation) to simple C<<hn>> element but Xatena converts it to C<<div class="section">>

=item 3. Xatena support multiline definition list

=back

But Xatena supports Hatena::Diary compatible mode, you can change the behavior with a option.

  my $thx = Text::Xatena->new(hatena_compatible => 1);

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

L<Text::Hatena|Text::Hatena>

L<http://hatenadiary.g.hatena.ne.jp/keyword/%E3%81%AF%E3%81%A6%E3%81%AA%E8%A8%98%E6%B3%95%E4%B8%80%E8%A6%A7>>


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
