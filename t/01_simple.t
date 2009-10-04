use strict;
use warnings;
use Test::More tests => 3;

use YAML;
use Template;

my $tt = Template->new;
my $data = [ { foo => 'bar' }, { foo => 'baz' } ];

ok(
	$tt->process(
		\"[% USE YAML = YAML.Encode %][% YAML.dump( struct ) %]",
		{ struct => $data },
		\my $out,
	)
);

ok( !$tt->error );

is_deeply( YAML::Load($out), $data );
