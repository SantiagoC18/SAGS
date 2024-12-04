
src="https://cdn.jsdelivr.net/npm/sweetalert2@11"

type="text/javascript";

    function validar() {
        var nombre_proyecto = document.getElementById("project-name");
        var descripcion = document.getElementById("description");
        var Objetivo = document.getElementById("objective");
        var fecha = document.getElementById("deadline");


        if (nombre_proyecto.value == "" || descripcion.value == "" || Objetivo.value == ""|| fecha.value == "") {
                Swal.fire({
                title: "Celda vacía",
                text: "Por Favor revise y complete todos sus datos",
                icon: "warning",
                confirmButtonColor: "#3085d6",
            });
            return false;
        }

            else {
                Swal.fire({
                title: "Datos Correctos",
                icon: "success",
                confirmButtonColor: "#3085d6",
                timer: 1500,
            });
                return true;
            }
        };

