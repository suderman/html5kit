Modernizr.addTest('csspointerevents', function(){
    var element = document.createElement('x'),
        documentElement = document.documentElement,
        getComputedStyle = window.getComputedStyle,
        supports;
    if(!('pointerEvents' in element.style)){
        return false;
    }
    element.style.pointerEvents = 'auto';
    element.style.pointerEvents = 'x';
    documentElement.appendChild(element);
    supports = getComputedStyle && 
        getComputedStyle(element, '').pointerEvents === 'auto';
    documentElement.removeChild(element);
    return !!supports;
});
