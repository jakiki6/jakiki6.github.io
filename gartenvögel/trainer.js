/*
	Note:
	  - this project is mostly maintained in German -> the vast majority of code isn't in English
	  - this is my first project with JavaScript and HTML

*/

var startDate = new Date();

console.log("Are you sure you wanna cheat?\nCheating is bad!");

var birds = [
	["https://www.nabu.de/stundedergartenvoegel/amsel-frank-derer.jpg", "amsel"],
	["https://www.nabu.de/stundedergartenvoegel/bachstelze-frank-derer.jpg", "bachstelze"],
	["https://www.nabu.de/stundedergartenvoegel/blaumeise-rita-priemer.jpg", "blaumeise"],
        ["https://www.nabu.de/stundedergartenvoegel/buchfink-frank-derer.jpg", "buchfink"],
        ["https://www.nabu.de/stundedergartenvoegel/buntspecht-frank-derer.jpg", "buntspecht"],
        ["https://www.nabu.de/stundedergartenvoegel/dohle-frank-derer.jpg", "dohle"],
        ["https://www.nabu.de/stundedergartenvoegel/eichelhaeher-frank-derer.jpg", "eichelhäher"],
        ["https://www.nabu.de/stundedergartenvoegel/elster-frank-derer.jpg", "elster"],
        ["https://www.nabu.de/stundedergartenvoegel/feldsperling-marco-frank.jpg", "feldsperling"],
        ["https://www.nabu.de/stundedergartenvoegel/fitis-steve-garvie.jpg", "fitis"],
        ["https://www.nabu.de/stundedergartenvoegel/gartenbaumlaeufer-frank-derer.jpg", "gartenbaumläufer"],
        ["https://www.nabu.de/stundedergartenvoegel/gartengrasmuecke-krzysztof-wesolowski.jpg", "gartengrasmücke"],
        ["https://www.nabu.de/stundedergartenvoegel/gartenrotschwanz-rosl-roessner.jpg", "gartenrotschwanz"],
        ["https://www.nabu.de/stundedergartenvoegel/gimpel-gaby-schroeder.jpg", "gimpel"],
        ["https://www.nabu.de/stundedergartenvoegel/girlitz-antje-schultner.jpg", "girlitz"],
        ["https://www.nabu.de/stundedergartenvoegel/goldammer-frank-derer.jpg", "goldammer"],
        ["https://www.nabu.de/stundedergartenvoegel/grauschnaepper-frank-derer.jpg", "grauschnäpper"],
        ["https://www.nabu.de/stundedergartenvoegel/gruenfink-frank-derer.jpg", "grünfink"],
        ["https://www.nabu.de/stundedergartenvoegel/hausrotschwanz-frank-derer.jpg", "hausrotschwanz"],
        ["https://www.nabu.de/stundedergartenvoegel/haussperling-frank-derer.jpg", "haussperling"],
        ["https://www.nabu.de/stundedergartenvoegel/heckenbraunelle-kerstin-kleinke.jpg", "heckenbraunelle"],
        ["https://www.nabu.de/stundedergartenvoegel/klappergrasmuecke-pia-reufsteck.jpg", "klappergrasmücke"],
        ["https://www.nabu.de/stundedergartenvoegel/kleiber-frank-derer.jpg", "keiber"],
        ["https://www.nabu.de/stundedergartenvoegel/kohlmeise-frank-derer.jpg", "kohlmeise"],
        ["https://www.nabu.de/stundedergartenvoegel/mauersegler-erlenbach.jpg", "mauersegler"],
        ["https://www.nabu.de/stundedergartenvoegel/mehlschwalbe-frank-derer.jpg", "mehlschwalbe"],
        ["https://www.nabu.de/stundedergartenvoegel/moenchsgrasmuecke-guenter-stoller.jpg", "mönchsgrasmücke"],
        ["https://www.nabu.de/stundedergartenvoegel/rabenkraehe-frank-derer.jpg", "rabenkrähe"],
        ["https://www.nabu.de/stundedergartenvoegel/rauchschwalbe-frank-derer.jpg", "rauchschwalbe"],
        ["https://www.nabu.de/stundedergartenvoegel/ringeltaube-frank-derer.jpg", "ringeltaube"],
        ["https://www.nabu.de/stundedergartenvoegel/rotkehlchen-helmut-erber.jpg", "rotkehlchen"],
        ["https://www.nabu.de/stundedergartenvoegel/saatkraehe-marco-frank.jpg", "saatkrähe"],
        ["https://www.nabu.de/stundedergartenvoegel/schwanzmeise-guenter-stoller.jpg", "schwanzmeise"],
        ["https://www.nabu.de/stundedergartenvoegel/singdrossel-christoph-bosch.jpg", "singdrossel"],
        ["https://www.nabu.de/stundedergartenvoegel/star-krzysztof-wesolowski.jpg", "star"],
        ["https://www.nabu.de/stundedergartenvoegel/stieglitz-kerstin-kleinke.jpg", "stieglitz"],
        ["https://www.nabu.de/stundedergartenvoegel/tannenmeise-frank-derer.jpg", "tannenmeise"],
        ["https://www.nabu.de/stundedergartenvoegel/tuerkentaube-frank-derer.jpg", "türkentaube"],
        ["https://www.nabu.de/stundedergartenvoegel/zaunkoenig-michael-gross.jpg", "zaunkönig"],
        ["https://www.nabu.de/stundedergartenvoegel/zilpzalp-gaby-schroeder.jpg", "zilpzalp"]
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
