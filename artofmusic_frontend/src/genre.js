class Genre {
  constructor(id, name) {
    this.id = id;
    this.name = name;
    if (Genre.all.find(genre => genre.id === this.id) == undefined) {
      Genre.all.push(this);
    }
  }
}

Genre.all = [];

Genre.renderChips = () => {
  fetch("http://localhost:3000/api/v1/genres").then(resp => resp.json()).then(json => {
    let chips = json.map(genre => {
      return `<div tabindex="0" class="chip" data-id="${genre.id}">${genre.name}<i class="material-icons">music_note</i></div>`;
    }).join("");
    document.querySelector("#sort").insertAdjacentHTML('afterend', chips);
  });
};

Genre.filterAlbums = (clicked) => {

  document.querySelector(".progress").style.display = "block";
  let ids = clicked.join(",");
  fetch(`http://localhost:3000/api/v1/genres/filter?ids=${ids}`).then(resp => resp.json()).then(json => {
    let filteredAlbums = [];
    json.forEach(genre => {
      genre.albums.forEach(album => {
        filteredAlbums.push(Album.makeAlbum(album));
      });
    });
    Album.page = filteredAlbums;
    reRender(filteredAlbums);
    scrollToTop();
    document.querySelector(".progress").style.display = "none";
  });
};
