$(document).ready(function() {
    reload()
});

function reload() {
    setInterval(function() { location.reload(); }, 10000);
    console.log("reload");
}