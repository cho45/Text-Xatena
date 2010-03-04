package Text::Xatena::LineScanner;

use strict;
use warnings;
use Carp;

sub new {
    my ($class, $str) = @_;
    bless {
        matched => undef,
        line    => 0,
        lines   => [ split /\n/, $str ]
    }, $class;
}

sub scan {
    my ($self, $regexp) = @_;
    my @matched = ($self->current =~ $regexp);
    if (@matched) {
        $self->{matched} = [ $self->{lines}->[$self->{line}], @matched ];
        $self->{line}++;
        $self->matched->[0];
    } else {
        $self->{matched} = undef;
    }
}

sub next {
    my ($self) = @_;
    my $ret = $self->current;
    $self->{line}++;
    $ret;
}

sub scan_until {
    my ($self, $regexp) = @_;
    my $ret = [];
    until ($self->eos || $self->scan($regexp)) {
        push @$ret, $self->current;
        $self->{line}++;
    }
    push @$ret, $self->matched->[0] if $self->matched;
    wantarray? @$ret : $ret;
}

sub matched {
    my ($self) = @_;
    $self->{matched};
}

sub current {
    my ($self) = @_;
    $self->eos && croak "End of String Error";
    $self->{lines}->[$self->{line}];
}

sub eos {
    my ($self) = @_;
    $self->{line} >= scalar @{ $self->{lines} };
}



1;
__END__



