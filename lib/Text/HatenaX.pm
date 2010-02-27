package Text::HatenaX;

use strict;
use warnings;
use UNIVERSAL::require;

use Text::HatenaX::LineScanner;
use Text::HatenaX::Node;
use Text::HatenaX::Node::Root;

our $VERSION = '0.01';

our $SYNTAXES = [
    'Text::HatenaX::Node::SuperPre',
    'Text::HatenaX::Node::StopP',
    'Text::HatenaX::Node::Blockquote',
    'Text::HatenaX::Node::Pre',
    'Text::HatenaX::Node::List',
    'Text::HatenaX::Node::Table',
    'Text::HatenaX::Node::Section',
];

sub new {
    my ($class, %opts) = @_;
    bless {
        %opts
    }, $class;
}

sub format {
    my ($self, $string) = @_;
    $self->_parse($string)->as_html;
}

sub _parse {
    my ($self, $string) = @_;

    my $s     = Text::HatenaX::LineScanner->new($string);
    my $stack = [ Text::HatenaX::Node::Root->new ];
    loop: until ($s->eos) {
        my $parent   = $stack->[-1];

        for my $pkg (@$SYNTAXES) {
            $pkg->use or die $@;
            $pkg->parse($s, $parent, $stack) and next loop;
        }

        # plain lines
        push @$parent, $s->scan(qr//);
    }
    $stack->[0];
}

1;
__END__

=head1 NAME

Text::HatenaX -

=head1 SYNOPSIS

  use Text::HatenaX;

=head1 DESCRIPTION

Text::HatenaX is

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
