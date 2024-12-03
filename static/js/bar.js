let menu = document.querySelector('#menu-icon');
let navbar = document.querySelector('.navbar');

menu.onclick = () => {
    menu.classList.toggle('bx-x');
    navbar.classList.toggle('open');
}

let registro = document.getElementById('registro');

registro.addEventListener('click', () => {
    window.location.href="registrar_pro";
}) 