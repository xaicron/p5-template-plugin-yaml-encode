use strict;
use warnings;
use Test::More tests => 3;

use YAML;
use utf8;
use Template;

my $file = 't/data/04.yaml';
my $data = 

my $tt = Template->new({
	ENCDOING => 'utf8',
});

ok(
	$tt->process(
		\"[% USE YAML = YAML.Encode('cp932') %][% data = YAML.undumpfile('$file') %][% YAML.dump(data) %]",
		{},
		\my $out,
	)
);

ok( !$tt->error );

is_deeply( YAML::Load($out), [qw/ほげ ふが ぴよ/] );
