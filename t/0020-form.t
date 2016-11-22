use v6;
use Test; 
use lib <lib>;

plan 5;

use-ok 'HTML::Tag::Tags', 'HTML::Tag::Tags can be use-d';
use HTML::Tag::Tags;
use-ok 'HTML::Tag::Macro::Form', 'HTML::Tag::Macro::Form can be use-d';
use HTML::Tag::Macro::Form;

ok my $form = HTML::Tag::Macro::Form.new(:form-action('/')), 'HTML::Tag::Macro::Form instantated';

my @def = ( { username => { }},
	    { password => { }},
	    { submit   => { type  => 'submit',
			    value => 'Login', }},
	  );

$form.def = @def;

is $form.render, '<form method="POST" name="form" action="/"><input name="username" id="form-username" type="text"><input name="password" id="form-password" type="text"><input name="submit" id="form-submit" type="submit"></form>', 'HTML::Tag::Macro::Form minimal def';

