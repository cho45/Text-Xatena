package Text::Xatena;

use strict;
use warnings;
use UNIVERSAL::require;

use Text::Xatena::LineScanner;
use Text::Xatena::Node;
use Text::Xatena::Node::Root;
use Text::Xatena::Inline;

our $VERSION = '0.01';

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

    for my $pkg (@$SYNTAXES) {
        $pkg->use or die $@;
    }

    bless {
        %opts
    }, $class;
}

sub format {
    my ($self, $string, %opts) = @_;
    $opts{inline} ||= Text::Xatena::Inline->new;
    $self->_parse($string)->as_html(%opts);
}

sub _parse {
    my ($self, $string) = @_;

    my $s     = Text::Xatena::LineScanner->new($string);
    my $root  = Text::Xatena::Node::Root->new ;
    my $stack = [ $root ];
    loop: until ($s->eos) {
        my $parent   = $stack->[-1];

        for my $pkg (@$SYNTAXES) {
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
  Text::Xatena->format($string);

=head1 DESCRIPTION

Text::Xatena is a text-to-html converter.

Text::Xatena is comfortably to writing usual diary and blog,
especially for programmers, writers treating long text.

=head2 What is Xatena

Xatena syntax is kind of Hatena syntax (implemented as Text::Hatena),
but independent from Hatena services. For example, there is no id: notation.

Most block level syntaxes are supported and more compatibility with Hatena::Diary
than Text::Hatena.

And don't support rare syntax or not applying to structured html.

=head3 SYNTAX

Basically, Xatena convert single line breaks to <br/> and
double line breaks to <p> element except "Stop P" syntax.

  fooo
  bar

  baz

is convert to

  <p>fooo<br/>bar</p>
  <p>baz</p>

This behavior is incompatible with Hatena,
because I think most people like this.

You can change this behavior by writing 1 line.

=head4 Blockquote

  >>
  quoted text

  foobar
  <<

is convert to

  <blockquote>
  <p>quoted text</p>
  <p>foobar</p>
  </blockquote>

=head4 Pre

  >|
  pre <a href="">formatted</a>
  |<

is convert to

  <pre>
  pre <a href="">formatted</a>
  </pre>

=head4 Super pre

  >||
  super pre <a>
  ||<

  >|perl|
  use Xatena;
  ||<

is convert to

  <pre>
  super pre &lt;a&gt;
  </pre>

  <pre class="code lang-perl">
  use Xatena;
  </pre>

=head4 Stop P

Stop insert p or br.

  ><ins><
  foobar
  ></ins><

is convert to

  <ins>
  <p>foobar</p>
  </ins>

=head4 Section

Create structured sections by * following heading.

  * head1

  foobar

  ** head2

  *** head3


=head4 List

  - ul
  - ul
  -- ul
  -- ul
  --- ul
  - ul

  + ol
  + ol
  ++ ol
  ++ ol
  +++ ol
  + ol

  - ul
  - ul
  -+ ol
  -+ ol
  -+ ol
  - ul

  :definition:description
  :definition:description


  :definition:
  :: description
  :definition:
  :: description

=head4 Table

  |*foo|*bar|*baz|
  |test|test|test|
  |test|test|test|

=head4 Inline syntaxes

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

=item Deter inline syntaxes syntax

  []http://example.com/[]

=back

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
