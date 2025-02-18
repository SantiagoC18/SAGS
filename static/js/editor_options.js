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

    edit.appendChild(shape);
    makeDraggable(shape);
}



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

function makeInteractive(element) {
    interact(element)
        .draggable({
            inertia: true,
            modifiers: [
                interact.modifiers.restrictRect({
                    restriction: "parent",
                    endOnly: true
                })
            ],
            listeners: {
                move(event) {
                    let target = event.target;
                    let x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
                    let y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

                    target.style.transform = `translate(${x}px, ${y}px)`;
                    target.setAttribute('data-x', x);
                    target.setAttribute('data-y', y);
                }
            }
        })
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