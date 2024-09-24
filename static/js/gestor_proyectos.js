
const developerBtn = document.getElementById('developerBtn');
const adminBtn = document.getElementById('adminBtn');
const developerView = document.getElementById('developerView');
const adminView = document.getElementById('adminView');



developerBtn.addEventListener('click', () => {
    
    developerBtn.classList.add('select')
    adminBtn.classList.remove('select')
    developerView.classList.add('active')
    developerView.classList.remove('view-section')
    adminView.classList.add('view-section')
    adminView.classList.remove('active')
});

adminBtn.addEventListener('click', () => {
    
    developerBtn.classList.remove('select')
    adminBtn.classList.add('select')
    developerView.classList.add('view-section')
    developerView.classList.remove('active')
    adminView.classList.add('active')
    adminView.classList.remove('view-section')
});
