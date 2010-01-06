package Template::Plugin::YAML::Encode;

use strict;
use warnings;
use 5.008001;
use Encode qw/find_encoding/;
use YAML qw/Load Dump LoadFile DumpFile/;
use base qw/Template::Plugin/;

our $VERSION = '0.02';

my $DEFAULT_ENCODING = find_encoding 'utf8';

sub new {
	my ($class, $context, $encode) = @_;
	$class = ref $class || $class;
	$encode ||= $DEFAULT_ENCODING;
	$encode = ref $encode =~ /^Encode/ ? $encode : find_encoding $encode;
	
	$context->define_filter('yaml', \&dump, 0);
	bless {
		_CONTEXT => $context,
		_encode  => $encode,
	}, $class;
}

sub dump {
	my $self = shift;
	return Dump @_;
}

my  %_escape_table = (
	' '  => '&nbsp;',
	'"'  => '&quot;',
	'&'  => '&amp;',
	'<'  => '&lt;',
	'>'  => '&gt;',
	"\n" => "<br>\n",
	"'"  => '&#39;',
);
sub dump_html {
	my $self = shift;
	my $yaml = Dump @_;
	$yaml =~ s/([ "&<>'\n])/$_escape_table{$1}/g;
	
	return $yaml;
}

sub undump {
	my $self = shift;
	my $data = Load @_;
	return $data unless $self->{_encode};
	
	return Load $self->{_encode}->decode( Dump $data );
}

sub dumpfile {
	my $self = shift;
	return DumpFile @_;
}

sub undumpfile {
	my $self = shift;
	my $data = LoadFile @_;
	return $data unless $self->{_encode};
	
	return Load $self->{_encode}->decode( Dump $data );
}

1;
__END__

=head1 NAME

Template::Plugin::YAML::Encode - Encode supported YAML

=head1 SYNOPSIS

  use Template;
  
  my $tt = Template->new({
      ENCODING => 'utf8',
  });
  
  [% USE YAML = YAML.Encode %]
  [% YAML.dump(variable) %]
  [% YAML.dump_html(variable) %]
  [% value = YAML.undump(yaml_string) %]
  [% YAML.dumpfile(filename, variable) %]
  [% value = YAML.undumpfile(filename) %]

=head1 DESCRIPTION

Template::Plugin::YAML::Encode is L<Template::Plugin::YAML>-compatible interface.

  [% USE YAML = YAML.Encode %]

Default encoding utf-8. To change the encoding argument should give.

  [% USE YAML = YAML.Encode('euc-jp') %]

=head1 METHODS

=over

=item dump( @variables )

=item dump_html( @variables )

=item undump( $string )

=item dumpfile( $file, @variables )

=item undumpfile( $file )

=back

=head1 AUTHOR

Yuji Shimada E<lt>xaicron {at} gmail.comE<gt>

=head1 SEE ALSO

L<Template::Plugin::YAML>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
