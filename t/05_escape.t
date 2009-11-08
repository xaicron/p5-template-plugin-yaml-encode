use strict;
use warnings;
use Test::More;

use utf8;
use Template::Context;
use Template::Plugin::YAML::Encode;

my $data = [
	q{<fuga>},
	q{piyo&piyo},
	qq{foo\nbar},
	q{'baz'},
];

my $yaml = Template::Plugin::YAML::Encode->new(Template::Context->new);
is $yaml->dump_html({quot => q{"hoge"}}), "---<br>\nquot:&nbsp;&#39;&quot;hoge&quot;&#39;<br>\n";
is $yaml->dump_html({tag  => q{<fuga>}}), "---<br>\ntag:&nbsp;&#39;&lt;fuga&gt;&#39;<br>\n";
is $yaml->dump_html({amp  => q{piyo&piyo}}), "---<br>\namp:&nbsp;piyo&amp;piyo<br>\n";
is $yaml->dump_html({br   => qq[foo\x{a}bar]}), "---<br>\nbr:&nbsp;&quot;foo\\nbar&quot;<br>\n";
is $yaml->dump_html({sq   => q{'baz'}}), "---<br>\nsq:&nbsp;&quot;&#39;baz&#39;&quot;<br>\n";

done_testing;
