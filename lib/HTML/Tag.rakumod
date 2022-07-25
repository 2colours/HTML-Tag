use v6;
use XML::Entity::HTML;

class HTML::Tag
{
    has Hash $.attr  is rw = {};
    has      $.id    is rw;
    has      $.class is rw;
    has      $.style is rw;
    has      $.name  is rw;
    
    method mktag(:$prefix, :$suffix = '>') {
	my $tag;
	$tag = $prefix if $prefix;
        constant %self-resolving = :checked, :disabled, :readonly, :required, :autofocus;
	$tag ~= $.attr.keys.sort.map({
                           when %self-resolving{$_} { $_ }
			   when 'value'     { " value=\"{encode-html-entities($.attr<value>.Str)}\"" } 
			   default          { " $_=\"{$.attr{$_}}\"" };
			 }).join;
	$tag ~= $suffix if $suffix;
	return $tag;
    }

    method do-assignments() {
	$.attr<id>    = $!id    if $!id;
	$.attr<class> = $!class if $!class;
	$.attr<style> = $!style if $!style;
	$.attr<name>  = $!name  if $!name;
    }
}

class HTML::Tag::Raw
{
    has $.text is rw = '';

    method render() {
        $.text
    }
}

class HTML::Tag::Link-tag is HTML::Tag
{
    has $.href is rw;
    has $.target is rw;
    has $.rel is rw;
    has $.type is rw;

    method do-assignments() {
	$.attr<href>   = $.href   if $.href;
	$.attr<target> = $.target if $.target;
	$.attr<rel>    = $.rel    if $.rel;
	$.attr<type>   = $.type   if $.type;
        nextsame
    }
}

class HTML::Tag::Table-tag is HTML::Tag
{
    has Int $.colspan is rw;

    method do-assignments() {
	$.attr<colspan> = $.colspan if $.colspan.defined;
        nextsame
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
    has     $.value     is rw;
    has     $.form      is rw;

    method do-assignments() {
	$.attr<disabled>  = $.disabled  if $.disabled;
	$.attr<readonly>  = $.readonly  if $.readonly;
	$.attr<required>  = $.required  if $.required;
	$.attr<autofocus> = $.autofocus if $.autofocus;
	$.attr<maxlength> = $.maxlength if $.maxlength.defined;
	$.attr<size>      = $.size      if $.size.defined;
	$.attr<value>     = $.value     if $.value;
	$.attr<form>      = $.form      if $.form;
        nextsame
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
	$tag ~= @.text.map({ next without $_;
                                   .?render // encode-html-entities(.Str)
		    }).join;
	return $tag ~ "</$T>";
    }
}

=begin pod

=head1 AUTHOR

Mark Rushing mark@orbislumen.net

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod
