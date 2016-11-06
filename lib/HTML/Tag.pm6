use v6;
use HTML::Entity;

=begin pod

=NAME HTML - Simple HTML Tag Generators

=SYNOPSIS

=begin code
use HG::HTML;

say HTML::p.new(:text('This is my paragraph'), :class('pretty')).render;
# <p class="pretty">This is my paragraph</p>

my $link = HTML::a.new(:text('paragraph'), :href('http://dom.com'));
say HTML::p.new(:text("This is my $link"), :class('pretty')).render;

=end code

=end pod

class HTML
{
    has Hash $.attr is rw = {};
    has Str  $.id is rw;
    has Str  $.class is rw;
    
    method mktag(:$prefix, :$suffix = '>') {
	my $tag;
	$tag = $prefix if $prefix;
	for $.attr.keys -> $a {
	    $tag ~= " $a=\"{$.attr<<$a>>}\"" if $.attr<<$a>>;
	}
	$tag ~= $suffix if $suffix;
	return $tag;
    }

    method do-assignments() {
	$!attr<id>    = $!id if $!id;
	$!attr<class> = $!class if $!class;
    }
}

role HTML::generic-tag[$T]
{
    has @.text is rw = '';

    method render() {
	self.do-assignments;
	my $tag = self.mktag(prefix => "<$T");
	for @.text -> $t {
	    $tag ~= $t ~~ HTML ?? $t.render !! encode-entities($t);
	}
	return $tag ~ "</$T>";
    }
} 

=head1 METHODS

=head2 HTML Tags

class HTML::a is HTML does HTML::generic-tag['a']
{
    has Str $.href is rw;
    has Str $.target is rw;

    method do-assignments() {
	callsame;
	$.attr<href>   = $.href   if $.href;
	$.attr<target> = $.target if $.target;
    }
}
class HTML::div  is HTML does HTML::generic-tag['div'] {}
class HTML::form is HTML does HTML::generic-tag['form']
{
    has Str $.name   is rw;
    has Str $.action is rw;
    has Str $.method is rw;

    method do-assignments() {
	callsame;
	$.attr<name>   = $.name if $.name;
	$.attr<action> = $.action if $.action;
	$.attr<method> = $.method if $.method;
   }	
}
class HTML::p    is HTML does HTML::generic-tag['p'] {}
class HTML::span is HTML does HTML::generic-tag['span'] {}

=head2 HTML Macros

class HTML::Macro::CSS
{
    has Str $.href is required;

    method render() {
	return "<link rel=\"stylesheet\" type=\"text/css\" href=\"$!href\">";
    }
}
