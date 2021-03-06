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


function click_on_image(winner, loser, gameId, gameDay, gameTimeET) {
	console.log(gameDay)
	console.log(gameTimeET)
	jQuery.ajax({
		data: {gameWinner: winner, gameId: gameId, gameDay: gameDay, gameTimeET: gameTimeET},
		dataType: 'script',
		type: 'post',
		url: "/update",
		success: function(status) {
			if (status === "true") {
				update_logo(winner, true);
				update_logo(loser, false);
			}
		}
	});
}

function update_logo(imageId, highlight) {
	var team_logo = document.getElementById(imageId)
	if (highlight == true) {
		team_logo.style.opacity = 1.0
		team_logo.style.borderBottom = '2px solid #f00'
	}
	else {
		team_logo.style.opacity = 0.10
		team_logo.style.borderBottom = '2px solid transparent'
	}
}

function show_picked_team(picked_team, home_team, away_team) {
	if (picked_team == home_team) {
		update_logo(home_team, true)
		update_logo(away_team, false)
	}
	else {
		update_logo(home_team, false)
		update_logo(away_team, true)
	}
}