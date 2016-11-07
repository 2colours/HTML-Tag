use v6;
use HTML::Tag;

class HTML::Tag::a is HTML::Tag does HTML::Tag::generic-tag['a']
{
    has Str $.href is rw;
    has Str $.target is rw;

    method do-assignments() {
	callsame;
	$.attr<href>   = $.href   if $.href;
	$.attr<target> = $.target if $.target;
    }
}
class HTML::Tag::div  is HTML::Tag does HTML::Tag::generic-tag['div'] {}
class HTML::Tag::form is HTML::Tag does HTML::Tag::generic-tag['form']
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
class HTML::Tag::p    is HTML::Tag does HTML::Tag::generic-tag['p'] {}
class HTML::Tag::span is HTML::Tag does HTML::Tag::generic-tag['span'] {}
