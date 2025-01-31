function addShape(type) {
    let shape = document.createElement('div');
    shape.classList.add('shape', type);
    shape.style.left = '50px';
    shape.style.top = '50px';
    shape.draggable = false;

    document.getElementById('edit').appendChild(shape);
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
        element.style.position= 'absolute';
        element.style.left = `${e.clientX - ejeX}px`;
        element.style.top = `${e.clientY - ejeY}px`;

    });

    document.addEventListener("mouseup", () => {
        isDragging = false;
        element.style.cursor = 'grab';
    });
}
