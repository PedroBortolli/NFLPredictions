// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree
//= require jquery

function click_on_image(winner, loser, gameId) {
	//console.log(winner, id)
	var team_logo = document.getElementById(winner)
	team_logo.style.opacity = 1.0
	team_logo.style.borderBottom = '2px solid #f00'
	team_logo = document.getElementById(loser)
	team_logo.style.opacity = 0.25
	team_logo.style.borderBottom = '2px solid transparent'
	jQuery.ajax({
		data: {gameWinner: winner, gameId: gameId},
		dataType: 'script',
		type: 'post',
		url: "/update"
	});
}