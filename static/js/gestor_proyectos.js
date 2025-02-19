const developerBtn = document.getElementById('developerBtn');
const adminBtn = document.getElementById('adminBtn');
const developerView = document.getElementById('developerView');
const adminView = document.getElementById('adminView');

developerBtn.addEventListener('click', () => {
    developerBtn.classList.add('select');
    adminBtn.classList.remove('select');
    developerView.classList.add('active');
    developerView.classList.remove('view-section');
    adminView.classList.add('view-section');
    adminView.classList.remove('active');
});

adminBtn.addEventListener('click', () => {
    developerBtn.classList.remove('select');
    adminBtn.classList.add('select');
    developerView.classList.add('view-section');
    developerView.classList.remove('active');
    adminView.classList.add('active');
    adminView.classList.remove('view-section');
});

document.addEventListener("DOMContentLoaded", function () {
    let proyectoSeleccionado = null;

    document.querySelectorAll(".asignar-btn").forEach(btn => {
        btn.addEventListener("click", async function () {
            proyectoSeleccionado = this.getAttribute("data-proyecto-id");
            document.getElementById("modalAsignar").style.display = "flex"; // Mostrar modal

            // Cargar lista de usuarios desde el backend
            try {
                const response = await fetch("/get_usuarios");
                if (!response.ok) throw new Error("Error al obtener usuarios");

                const usuarios = await response.json();
                const lista = document.getElementById("listaUsuarios");
                lista.innerHTML = ""; // Limpiar la lista antes de añadir nuevos elementos

                usuarios.forEach(usuario => {
                    const li = document.createElement("li");
                    li.innerHTML = `
                        <input type="checkbox" value="${usuario.id}" /> ${usuario.nombre} - ${usuario.cargo}
                    `;
                    lista.appendChild(li); // Agregar cada usuario como un <li>
                });
            } catch (error) {
                console.error("Error cargando usuarios:", error);
            }
        });
    });

    document.getElementById("btnAsignarUsuarios").addEventListener("click", async function () {
        const seleccionados = Array.from(document.querySelectorAll("#listaUsuarios input:checked"))
                    .map(input => input.value);

        try {
            await fetch("/asignar_usuarios", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ proyecto_id: proyectoSeleccionado, usuarios: seleccionados })
            });

            cerrarModal();
        } catch (error) {
            console.error("Error al asignar usuarios:", error);
        }
    });

    document.getElementById("btnCancelar").addEventListener("click", cerrarModal);
});

function cerrarModal() {
    document.getElementById("modalAsignar").style.display = "none"; // Ocultar modal
}
