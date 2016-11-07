use v6;
use HTML::Entity;

class HTML::Tag
{
    has Hash $.attr  is rw = {};
    has Str  $.id    is rw;
    has Str  $.class is rw;
    has Str  $.style is rw;
    
    method mktag(:$prefix, :$suffix = '>') {
	my $tag;
	$tag = $prefix if $prefix;
	for $.attr.keys -> $a {
	    $tag ~= " $a=\"{$.attr«$a»}\"" if $.attr«$a»;
	}
	$tag ~= $suffix if $suffix;
	return $tag;
    }

    method do-assignments() {
	$!attr<id>    = $!id    if $!id;
	$!attr<class> = $!class if $!class;
	$!attr<style> = $!style if $!style;
    }
}

role HTML::Tag::generic-single-tag[$T]
{
    method render() {
	self.do-assignments;
	my $tag = self.mktag(:prefix("<$T"));
	return $tag;
    }
}

role HTML::Tag::generic-tag[$T]
{
    has @.text is rw = '';

    method render() {
	self.do-assignments;
	my $tag = self.mktag(:prefix("<$T"));
	@.text.map: { $tag ~= $_ ~~ HTML::Tag ?? $_.render !! encode-entities($_) };
	return $tag ~ "</$T>";
    }
}
