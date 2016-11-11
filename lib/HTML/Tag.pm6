use v6;
use HTML::Entity;

class HTML::Tag
{
    has Hash $.attr  is rw = {};
    has Str  $.id    is rw;
    has Str  $.class is rw;
    has Str  $.style is rw;
    has Str  $.name  is rw;
    
    method mktag(:$prefix, :$suffix = '>') {
	my $tag;
	$tag = $prefix if $prefix;
	$.attr.keys.map: { when 'checked'   { $tag ~= ' checked' }
			   when 'disabled'  { $tag ~= ' disabled' }
			   when 'readonly'  { $tag ~= ' readonly' }
			   when 'required'  { $tag ~= ' required' }
			   when 'autofocus' { $tag ~= ' autofocus' }
			   default          { $tag ~= " $_=\"{$.attr«$_»}\"" };
			 }
	$tag ~= $suffix if $suffix;
	return $tag;
    }

    method do-assignments() {
	$!attr<id>    = $!id    if $!id;
	$!attr<class> = $!class if $!class;
	$!attr<style> = $!style if $!style;
	$!attr<name>  = $!name  if $!name;
    }
}

class HTML::Tag::Link-tag is HTML::Tag
{
    has Str $.href is rw;
    has Str $.target is rw;
    has Str $.rel is rw;

    method do-assignments() {
	callsame;
	$.attr<href>   = $.href   if $.href;
	$.attr<target> = $.target if $.target;
	$.attr<rel>    = $.target if $.rel;
    }
}

class HTML::Tag::Table-tag is HTML::Tag
{
    has Int $.colspan is rw;

    method do-assignments() {
	callsame;
	$.attr<colspan> = $.colspan if $.colspan.defined;
    }
}

class HTML::Tag::Form-tag is HTML::Tag
{
    has     $.disabled  is rw;
    has     $.readonly  is rw;
    has     $.required  is rw;
    has     $.autofocus is rw;
    has Int $.maxlength is rw;
    has Int $.size      is rw;
    has Str $.value     is rw;
    has Str $.form      is rw;

    method do-assignments() {
	callsame;
	$.attr<disabled>  = $.disabled  if $.disabled;
	$.attr<readonly>  = $.readonly  if $.readonly;
	$.attr<required>  = $.required  if $.required;
	$.attr<autofocus> = $.autofocus if $.autofocus;
	$.attr<maxlength> = $.maxlength if $.maxlength.defined;
	$.attr<size>      = $.size      if $.size.defined;
	$.attr<value>     = $.value     if $.value;
	$.attr<form>      = $.form      if $.form;
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
	@.text.map: { $tag ~= $_.^name ~~ /HTML\:\:Tag/ ?? $_.render !! encode-entities($_) };
	return $tag ~ "</$T>";
    }
}
