package Text::HatenaX;

use strict;
use warnings;
use UNIVERSAL::require;

use Text::HatenaX::LineScanner;
use Text::HatenaX::Node;
use Text::HatenaX::Node::Root;
use Text::HatenaX::Inline;

our $VERSION = '0.01';

our $SYNTAXES = [
    'Text::HatenaX::Node::SuperPre',
    'Text::HatenaX::Node::StopP',
    'Text::HatenaX::Node::Blockquote',
    'Text::HatenaX::Node::Pre',
    'Text::HatenaX::Node::List',
    'Text::HatenaX::Node::DefinitionList',
    'Text::HatenaX::Node::Table',
    'Text::HatenaX::Node::Section',
    'Text::HatenaX::Node::Comment',
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
    $opts{inline} ||= Text::HatenaX::Inline->new;
    $self->_parse($string)->as_html(%opts);
}

sub _parse {
    my ($self, $string) = @_;

    my $s     = Text::HatenaX::LineScanner->new($string);
    my $root  = Text::HatenaX::Node::Root->new ;
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

Text::HatenaX - Text-to-HTML converter with Hatena syntax.

=head1 SYNOPSIS

  use Text::HatenaX;

  my $thx = Text::HatenaX->new;
  Text::HatenaX->format($string);

=head1 DESCRIPTION

Text::HatenaX is a text-to-html converter.

Text::HatenaX is comfortably to writing usual diary and blog,
especially for programmers, writers treating long text.

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
