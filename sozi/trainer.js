/*
	Note:
	  - this project is mostly maintained in German -> the vast majority of code isn't in English
	  - this is my first project with JavaScript and HTML
          - this is a copy of another trainer
*/

var startDate = new Date();

console.log("Are you sure you wanna cheat?\nCheating is bad!");

var birds = [
	["https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Grundsteinlegung_MiQua-7004_%28cropped%29.jpg/1200px-Grundsteinlegung_MiQua-7004_%28cropped%29.jpg", "armin laschet"],
	["https://www.die-linke-thl.de/fileadmin/_processed_/c/b/csm_susannehennigwellsow01_97c25950ce.jpg", "susanne hennig-wellsow"],
	["https://www.zdf.de/assets/janine-wissler-110~2400x1350?cb=1620135466710", "janine wissler"],
	["https://www.bundestag.de/resource/image/519652/2x3/316/475/1d66837d4b7ec224b7f16272bd99ac58/Il/gauland_alexander_gross.jpg", "dr alexander gauland"],
	["https://www.tagesspiegel.de/images/klausur-der-spd-bundestagsfraktion/25454112/1-format43.jpg", "saskia esken"],
	["https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Hart_aber_fair_2018-10-08-8555.jpg/1200px-Hart_aber_fair_2018-10-08-8555.jpg", "norbert walter-borsians"],
	["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/2020-02-14_Christian_Lindner_%28Bundestagsprojekt_2020%29_by_Sandro_Halank%E2%80%932.jpg/1200px-2020-02-14_Christian_Lindner_%28Bundestagsprojekt_2020%29_by_Sandro_Halank%E2%80%932.jpg", "christian lindner"],
	["https://pbs.twimg.com/profile_images/1384073872169861124/sodIypTE_400x400.jpg", "annalena baerbock"],
	["https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Maischberger_-_2018-06-20-6596.jpg/1200px-Maischberger_-_2018-06-20-6596.jpg", "robert habeck"]
]
var max = birds.length;
birds = shuffle(birds);
var bird_choosen = birds.pop();
document.getElementById("image").src = bird_choosen[0];
var index = 0;
var score = 0;

function trainer() {
	var input = document.getElementById("name").value;
	var image = document.getElementById("image");

	if (input == "idspispopd") {
		score = max;
		stats();
	}

	if (bird_choosen == undefined) {
		bird_choosen = birds.pop();
	}
	if (input.toLowerCase() == bird_choosen[1]) {
		if (birds.length == 0) {
			score += 1;
			alert("Richtig!");
			stats();
		}
		bird_choosen = birds.pop();
		image.src = bird_choosen[0];
		score += 1;
		document.getElementById("name").value = "";
		alert("Richtig!");
	} else {
		if (birds.length == 0) {
			alert("Falsch!\nRichtig wäre: " + bird_choosen[1]);
                        stats();
                }
		alert("Falsch!\nRichtig wäre: " + bird_choosen[1]);
		bird_choosen = birds.pop(); 
                image.src = bird_choosen[0];
		document.getElementById("name").value = "";
	}
}

function shuffle(a) {
    var j, x, i;
    for (i = a.length - 1; i > 0; i--) {
        j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
    return a;
}

function stats () {
	var seconds = Math.floor(((new Date()).getTime() - startDate.getTime()) / 1000);
	var minutes = Math.floor(seconds / 60);
	var hours = Math.floor(minutes / 60);
	minutes = minutes % 60;
	seconds = seconds % 60;
	alert("Du hast " + String(score / max * 100) + "%  in einer Zeit von " + String(hours).padStart(2, "0") + ":" + String(minutes).padStart(2, "0") + ":" + String(seconds).padStart(2, "0") + " erreicht!");
	location.reload();
}

// Get the input field
var input = document.getElementById("name");

// Execute a function when the user releases a key on the keyboard
input.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    document.getElementById("check").click();
  }
});
