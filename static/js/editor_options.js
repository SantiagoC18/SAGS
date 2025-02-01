function addShape(type) {
    let edit = document.getElementById('edit');
    let shape = document.createElement('div');
    shape.classList.add(type);

   if (type === 'line'){
    shape.classList.add('line');
    let text = document.createElement('div');
    text.classList.add('text');
    text.innerText = 'Extends';
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
        element.style.position= 'absolute';
        element.style.left = `${e.clientX - ejeX}px`;
        element.style.top = `${e.clientY - ejeY}px`;

    });

    document.addEventListener("mouseup", () => {
        isDragging = false;
        element.style.cursor = 'grab';
    });
}
