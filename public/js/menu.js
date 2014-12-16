$(document).ready(function() 
{
	$("ul.nav.navbar-nav li").click(function() {
		$("ul.nav.navbar-nav li.active").removeClass("active");
		$(this).addClass("active");
	});
});