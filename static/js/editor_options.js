function addShape(type) {
    let shape = document.createElement('div');
    shape.classList.add('shape', type);
    shape.style.left = '50px';
    shape.style.top = '50px';
    shape.draggable = false;

    document.getElementById('edit').appendChild(shape);
    makeDraggable(shape, resizer);
}

