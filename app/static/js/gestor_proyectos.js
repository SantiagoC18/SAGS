document.addEventListener("DOMContentLoaded", function () {
    const developerBtn = document.getElementById("developerBtn");
    const adminBtn = document.getElementById("adminBtn");
    const developerView = document.getElementById("developerView");
    const adminView = document.getElementById("adminView");
    const modal = document.getElementById("modalAsignar");
    const listaUsuarios = document.getElementById("listaUsuarios");
    const btnAsignarUsuarios = document.getElementById("btnAsignarUsuarios");
    const btnCancelar = document.getElementById("btnCancelar");
    const modalTitulo = document.getElementById("modalTitulo");
    const modalScrumMaster = document.getElementById("modalScrumMaster");

    let proyectoSeleccionado = null;

    // Cambiar entre vistas
    if (developerBtn && adminBtn) {
        developerBtn.addEventListener("click", () => toggleView(developerBtn, adminBtn, developerView, adminView));
        adminBtn.addEventListener("click", () => toggleView(adminBtn, developerBtn, adminView, developerView));
    }

    function toggleView(activeBtn, inactiveBtn, activeView, inactiveView) {
        activeBtn.classList.add("select");
        inactiveBtn.classList.remove("select");
        activeView.classList.add("active");
        activeView.classList.remove("view-section");
        inactiveView.classList.add("view-section");
        inactiveView.classList.remove("active");
    }

    // Asignar evento a los botones "Asignar"
    document.querySelectorAll(".asignar-btn").forEach(btn => {
        btn.addEventListener("click", async function () {
            proyectoSeleccionado = this.getAttribute("data-proyecto-id");
            await cargarProyecto(proyectoSeleccionado);
            await cargarUsuarios(proyectoSeleccionado);
            modal.style.display = "flex"; // Mostrar modal
        });
    });

    // Cargar datos del proyecto seleccionado
    async function cargarProyecto(proyecto_id) {
        try {
            const response = await fetch(`/get_proyecto/${proyecto_id}`);
            if (!response.ok) throw new Error("Error al obtener datos del proyecto");

            const proyecto = await response.json();
            modalTitulo.textContent = `Asignar Usuarios a: ${proyecto.nombre}`;
            modalScrumMaster.textContent = `Scrum Master: ${proyecto.scrum_master}`;
        } catch (error) {
            console.error("Error al cargar datos del proyecto:", error);
        }
    }

    // Cargar usuarios desde el backend
    async function cargarUsuarios(proyecto_id) {
        try {
            const response = await fetch(`/get_usuarios/${proyecto_id}`);
            if (!response.ok) throw new Error("Error al obtener usuarios");

            const usuarios = await response.json();
            listaUsuarios.innerHTML = ""; // Limpiar la lista antes de añadir nuevos elementos

            usuarios.forEach(usuario => {
                const li = document.createElement("li");
                li.innerHTML = `
                    <label>
                        <input type="checkbox" value="${usuario.id}" />
                        ${usuario.nombre} - ${usuario.rol}
                    </label>
                `;
                listaUsuarios.appendChild(li);
            });
        } catch (error) {
            console.error("Error cargando usuarios:", error);
        }
    }

    // Asignar usuarios al proyecto
    btnAsignarUsuarios.addEventListener("click", async function () {
        const seleccionados = Array.from(document.querySelectorAll("#listaUsuarios input:checked"))
                                  .map(input => input.value);

        if (seleccionados.length === 0) {
            alert("Selecciona al menos un usuario.");
            return;
        }

        try {
            const response = await fetch("/asignar_usuarios", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ proyecto_id: proyectoSeleccionado, usuarios: seleccionados })
            });

            if (!response.ok) throw new Error("Error al asignar usuarios");

            cerrarModal();
            alert("Usuarios asignados con éxito.");
        } catch (error) {
            console.error("Error al asignar usuarios:", error);
            alert("Hubo un problema al asignar usuarios.");
        }
    });

    // Cerrar modal
    btnCancelar.addEventListener("click", cerrarModal);

    function cerrarModal() {
        modal.style.display = "none"; // Ocultar modal
        modalTitulo.textContent = "";
        modalScrumMaster.textContent = "";
        listaUsuarios.innerHTML = "";
    }
});
