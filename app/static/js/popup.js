var btnAbrirPopup1 = document.getElementById('btn-abrir-popup1'),
	overlay1 = document.getElementById('overlay1'),
	popup1 = document.getElementById('popup1'),
	btnCerrarPopup1 = document.getElementById('btn-cerrar-popup1');


if (btnAbrirPopup1) {
	btnAbrirPopup1.addEventListener('click', function () {
		overlay1.classList.add('active');
		popup1.classList.add('active');
	});
}

if (btnCerrarPopup1) {
	btnCerrarPopup1.addEventListener('click', function () {
		overlay1.classList.remove('active');
		popup1.classList.remove('active');
	});
}

var btnAbrirPopup2 = document.getElementById('btn-abrir-popup2'),
	overlay2 = document.getElementById('overlay2'),
	popup2 = document.getElementById('popup2'),
	btnCerrarPopup2 = document.getElementById('btn-cerrar-popup2');


if (btnAbrirPopup2) {
	btnAbrirPopup2.addEventListener('click', function () {
		overlay2.classList.add('active');
		popup2.classList.add('active');
	});
}

if (btnCerrarPopup2) {
	btnCerrarPopup2.addEventListener('click', function () {
		overlay2.classList.remove('active');
		popup2.classList.remove('active');
	});
}