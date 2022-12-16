valor = [];
document.querySelectorAll('.yui-dt1-col-email').forEach((e,i) => { 
 valor.push(e.querySelector('.yui-dt-liner').innerText) })

var count = {};
valor.forEach(function(i) { count[i] = (count[i]||0) + 1;});

let sortable = [];
for (var valorOrdendado in count) {
    sortable.push([valorOrdendado, count[valorOrdendado]]);
}

sortable.sort(function(a, b) {
    return b[1] - a[1];
});

