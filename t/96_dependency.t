use Test::Dependencies
	exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Text::HatenaX/],
	style   => 'light';
ok_dependencies();
