use strict;
use warnings;
use Test::More tests => 3;

use YAML;
use Template;

my $tt = Template->new({
	ENCDOING => 'utf8',
});
my $data = [ { foo => 'ほげ' }, { foo => 'ふが' } ];

ok(
	$tt->process(
		\"[% USE YAML = YAML.Encode %][% YAML.dump( struct ) %]",
		{ struct => $data },
		\my $out,
	)
);

ok( !$tt->error );

is_deeply( YAML::Load($out), $data );
