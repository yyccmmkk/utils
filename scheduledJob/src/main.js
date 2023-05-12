let sharp = require('sharp');
let m = require('./str.js');

sharp({
	text: {
		text:m.str,
		font: 'sans',
		rgba: true,
		width:400,
		align:'left',

	}
}).toFile(`../analysis/${m.date}.png`);


