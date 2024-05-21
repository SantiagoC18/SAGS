var btnAbrirPopup0 = document.getElementById('btn-abrir-popup0'),
	overlay = document.getElementById('overlay'),
	popup = document.getElementById('popup'),
	btnCerrarPopup0 = document.getElementById('btn-cerrar-popup0');


if (btnAbrirPopup0) {
	btnAbrirPopup0.addEventListener('click', function () {
		overlay.classList.add('active');
		popup.classList.add('active');
	});
}

if (btnCerrarPopup0) {
	btnCerrarPopup0.addEventListener('click', function () {
		overlay.classList.remove('active');
		popup.classList.remove('active');
	});
}

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