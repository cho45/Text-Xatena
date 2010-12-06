use YAML;
use Test::Dependencies
	exclude =>
		[qw/ opts Text::Xatena Filter::Util::Call Test::Base /];

local *Test::Dependencies::LoadFile = sub {
	my ($filename) = @_;
	my $data = YAML::LoadFile($filename);
	if ($filename eq 'META.yml') {
		delete $data->{build_requires}->{'ExtUtils::MakeMaker'};
		delete $data->{requires}->{'Filter::Util::Call'};
	}
	$data;
};


ok_dependencies();
