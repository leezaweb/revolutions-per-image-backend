class Album {
  constructor(id, artist, title, image, year, rating, likes, visual_artist, genres) {
    this.id = id;
    this.artist = artist;
    this.title = title;
    this.image = image;
    this.year = year;
    this.rating = rating;
    this.likes = likes;
    this.visual_artist = visual_artist;
    this.genres = genres;

    Album.concat.push(Object.assign({}, {
      'id': this.id,
      'body': `${this.artist}
              ${this.title}
              ${this.image}
              ${this.year}
          `
    }));
  }

  render() {
    return `<summary class="perm">
          <h6 class="visual-artist">${this.visual_artist.name}</h6>
          <div class="image-container"><a class="tooltipped" data-position="top" data-tooltip="${this.artist} - ${this.title}"><img src='${this.image}' class="image modal-trigger" data-id="${this.id}" data-artist="${this.visual_artist.id}" data-target="modal1" ></a></div>
          <!--<div class="artist">${this.artist}</div>
          <div class="title">${this.title}</div>
          <div class="year">${this.year}</div>
          <div><button class="delete" data-id="${this.id}">delete</button></div>//-->
          <div class="like-it"><span id="<3" data-id="${this.id}" class="like">❤️</span><span class="likes">${parseInt(this.likes)}</span> likes</div>
        </summary>`;
  }


tempRender() {
  return `<summary class="temp">
        <h6 class="visual-artist">${this.visual_artist.name}</h6>
        <div class="image-container"><a class="tooltipped" data-position="top" data-tooltip="${this.artist} - ${this.title} (${this.year})"><img src='${this.image}' class="image" data-id="" data-target="modal1" ></a></div>
        <div class="like-it"><span class="likes">${parseInt(this.likes)}</span> likes</div>
        <div class="add-it">
        <button class="btn" type="submit" name="action">add art
            <i class="material-icons right">add</i>
        </button>
        </div>
      </summary>`;
    }

}

Album.page = [];
Album.concat = [];
Album.updateLikes = (id) => {
  const albumJson = 'http://localhost:3000/api/v1/albums';
  fetch(`${albumJson}/${id}`, {
    body: JSON.stringify(id),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    method: 'PATCH'
  }).then(resp => console.log(resp));
};

Album.makeAlbum = (album) => {
  // debugger;
  return new Album(
    album.id,
    album.artist,
    album.title,
    album.image,
    album.year,
    album.rating,
    album.likes,
    album.visual_artist,
    album.genres
  );
};


Album.deleteIt = () => {
  const albumJson = 'http://localhost:3000/api/v1/albums';
  document.querySelector("article").addEventListener('click', function(e) {
    if (e.target.className.includes('delete')) {
      e.target.parentNode.parentNode.remove();
      let id = e.target.dataset.id;
      fetch(`${albumJson}/${id}`, {
        body: JSON.stringify(id),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        method: 'DELETE'
      }).then(resp => console.log(resp));
    }
  });
};

Album.searchAlbums = (query) => {
  let name = query;
  fetch(`http://localhost:3000/api/v1/albums/search?name=${name}`).then(resp => resp.json()).then(json => {
    let filteredAlbums = [];
    json.forEach(album => {
      filteredAlbums.push(Album.makeAlbum(album));
    });
    Album.page = filteredAlbums;//////////////////////////////////
    reRender(filteredAlbums);
  });
};