use v6;
use HTML::Tag::Tags;

class HTML::Tag::Macro::Form
{
    has @.def is rw;
    has %.input;
    has $.form-name is rw = 'form';

    method render() {
	my @elements;
	for @.def -> $element {
	    my $name  = $element.keys.first;
	    my %def   = $element{$name};
	    my %tagdef;
	    %tagdef<name> = $name;
	    %tagdef<id>   = "{$.form-name}\-$name";
	    %tagdef<class> = %def<class> if %def<class>:exists;
	    
	    if (%.input) {
		%tagdef<value> = %.input«$name» if (%.input«$name»:exists);
	    }
	    
	    @elements.push: HTML::Tag::input.new(|%tagdef);
	}
	return HTML::Tag::form.new(:name($.form-name),
				   :text(@elements)).render;
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
