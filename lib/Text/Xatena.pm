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
        push @$parent, $s->scan(qr//);
    }

    $root;
}

1;
__END__

=head1 NAME

Text::Xatena - Text-to-HTML converter with Hatena syntax.

=head1 SYNOPSIS

  use Text::Xatena;

  my $thx = Text::Xatena->new;
  Text::Xatena->format($string);

=head1 DESCRIPTION

Text::Xatena is a text-to-html converter.

Text::Xatena is comfortably to writing usual diary and blog,
especially for programmers, writers treating long text.

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
