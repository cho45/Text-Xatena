package Text::HatenaX;

use strict;
use warnings;
use Text::HatenaX::LineScanner;
use Text::HatenaX::Node qw(node);
our $VERSION = '0.01';

sub new {
    my ($class, %opts) = @_;
    bless {
        %opts
    }, $class;
}

sub format {
    my ($self, $string) = @_;
}

sub _parse {
    my ($self, $string) = @_;

    my $s     = Text::HatenaX::LineScanner->new($string);
    my $stack = [ node("Root")->new ];
    loop: until ($s->eos) {
        my $parent   = $stack->[-1];

        for my $name (qw(SuperPre StopP Blockquote List)) {
            node($name)->parse($s, $parent, $stack) and next loop;
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
