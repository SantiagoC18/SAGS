//Edición de formato de texto
function editText() {
    document.execCommand("bold");
}

function cursivaText() {
    document.execCommand("italic");
}

//Creación de figuras
function addShape(type) {
    let edit = document.getElementById('edit');
    let shape = document.createElement('div');
    shape.classList.add(type);

    if (type === 'extends') {
        shape.classList.add('line');
        let text = document.createElement('div');
        text.classList.add('text');
        text.innerText = '<<extends>>';
        shape.appendChild(text);
    }
    if (type === 'Text') {
        let cuadroTexto = document.createElement("input");
        cuadroTexto.type = "text";
        cuadroTexto.placeholder = "Escribe algo...";
        cuadroTexto.style.width = "150px";
        cuadroTexto.style.height = "30px";
        shape.appendChild(cuadroTexto);
    }
    if (type === 'generalizacion') {
        let svgContainer = document.createElement('div');
        svgContainer.classList.add('generalizacion');

        let svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        svg.setAttribute("width", "150");
        svg.setAttribute("height", "100");

        let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", "10");
        line.setAttribute("y1", "50");
        line.setAttribute("x2", "100");
        line.setAttribute("y2", "50");
        line.setAttribute("stroke", "black");
        line.setAttribute("stroke-width", "2");

        let arrow = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
        arrow.setAttribute("points", "100,40 120,50 100,60");
        arrow.setAttribute("fill", "white");
        arrow.setAttribute("stroke", "black");
        arrow.setAttribute("stroke-width", "2");


        svg.appendChild(line);
        svg.appendChild(arrow);
        svgContainer.appendChild(svg);
        edit.appendChild(svgContainer);
        makeDraggable(svgContainer);
    }

    edit.appendChild(shape);
    makeDraggable(shape);
    makeResizable(shape);

}


//Movimiento de Objetos
function makeDraggable(element) {
    let ejeX, ejeY, isDragging = false;

    element.addEventListener("mousedown", (e) => {
        isDragging = true;
        const rect = element.getBoundingClientRect();
        ejeX = e.clientX - rect.left;
        ejeY = e.clientY - rect.top;
        element.style.cursor = 'grabbing';
    });

    document.addEventListener("mousemove", (e) => {
        if (!isDragging) return;
        element.style.position = 'absolute';
        element.style.left = `${e.clientX - ejeX}px`;
        element.style.top = `${e.clientY - ejeY}px`;

    });

    document.addEventListener("mouseup", () => {
        isDragging = false;
        element.style.cursor = 'grab';
    });
}


function makeResizable(element) {
    interact(element)
        .resizable({
            edges: { left: true, right: true, bottom: true, top: true },
            listeners: {
                move(event) {
                    let target = event.target;
                    let { width, height } = event.rect;
                    target.style.width = width + 'px';
                    target.style.height = height + 'px';
                }
            }
        })
};


//Icons 
function addIcon(type) {
    let edit = document.getElementById('edit');
    let icon = document.createElement('img');

    if (type === 'arrow') {
        icon.src = 'https://img.icons8.com/ios/50/horizontal-line.png';
    }
    if (type === 'atributo') {
        icon.src = 'https://img.icons8.com/ios/50/ellipse-stroked--v1.png';

    } if (type === 'elipse_punteado') {
        icon.src = 'https://img.icons8.com/external-line-icons-royyan-wijaya/64/external-basic-geometricalist-line-icons-royyan-wijaya-26.png';
    }

    icon.classList.add('icon', 'resizable');
    icon.style.left = '50px';
    icon.style.top = '50px';
    icon.setAttribute('data-x', 0);
    icon.setAttribute('data-y', 0);

    edit.appendChild(icon);

    makeInteractive(icon);
}


//Formatos

function makeTable() {
    document.getElementById("extendido")

    let edit = document.getElementById('edit');
    let table = document.createElement("table");
    table.id = "dynamicTable";
    let thead = document.createElement("thead");
    let headerRow = document.createElement("tr");


    let headers = ["Casos de Uso Extendido", "RF", "CU"];
    headers.forEach(text => {
        let th = document.createElement("th");
        th.textContent = text;
        headerRow.appendChild(th);
    });

    thead.appendChild(headerRow);
    table.appendChild(thead);

    let tbody = document.createElement("tbody");
    let row = document.createElement("tr");

    headers.forEach(() => {
        let td = document.createElement("td");
        let input = document.createElement("input");
        input.type = "text";
        td.appendChild(input);
        row.appendChild(td);
    });

    tbody.appendChild(row);
    table.appendChild(tbody);

    // Agregar tabla al contenedor
    edit.appendChild(table);

}


