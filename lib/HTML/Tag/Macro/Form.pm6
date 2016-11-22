use v6;
use HTML::Tag::Tags;

class HTML::Tag::Macro::Form
{
    has @.def is rw;
    has %.input is rw;
    has $.form-name is rw = 'form';
    has $.action is rw;
    has $.id     is rw;

    method render() {
	my @elements;
	for @.def -> $element {
	    my $name   = $element.keys.first;
	    my %def    = $element{$name};
	    my %tagdef = ();
	    %tagdef<name>  = $name;
	    %tagdef<id>    = "{$.form-name}\-$name";
	    %tagdef<class> = %def<class> if %def<class>:exists;
	    %tagdef<type>  = %def<type>  if %def<type>:exists;

	    # Process input variables
	    my $var = %def<var>:exists ?? %def<var> !! $name;
	    if (%def<value>:exists) {
		%tagdef<value> = %def<value>;
	    }
	    elsif (%.input and %.input«$var»:exists) {
		%tagdef<value> = %.input«$var»;
	    }

	    my $tag = HTML::Tag::input.new(|%tagdef);
	    
	    if %def<nolabel>:exists {
		@elements.push: $tag;
	    } else {
		my $label = %def<label>:exists ?? %def<label> !! $name.tc;
		@elements.push: HTML::Tag::label.new(:text($label, $tag));
	    }
	}
	my $form = HTML::Tag::form.new(:name($.form-name),
				       :text(@elements));
	$form.action = $.action if $.action;
	$form.id     = $.id     if $.id;
	$form.render;
    }
}

=begin pod
    =begin code
    ( { name => { no-label => False,
		  label    => 'Name',
		  var      => 'name',
		  type     => 'text',
		  id       => '{$form-name}-$name',
		  class    => '',
		}
      },
    );
    =end code
=end pod
