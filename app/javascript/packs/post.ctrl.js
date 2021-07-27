import Services from "./services";
import Helper from "./helper";

export default class PostController {
    constructor(config) {
        this.config = config;
        this.postID = null;
        this.dataSource = [];
    }

    mount (params) {
        this.postID = params['id'];
        this.view();
    }

    view() {
        let currentPost = this.dataSource.find((article) => {
            return parseInt(article['id']) === parseInt(this.postID);
        });

        if (!currentPost) { return }

        let viewContainer = document.getElementById('post-container');
        viewContainer.innerHTML = currentPost.content

        let viewTitle = document.getElementById('post-title');
        viewTitle.innerHTML = currentPost.title;

        let viewThumbnail = document.getElementById('post-thumbnail');
        if (currentPost.image.indexOf('/assets/no-image') === -1){
            viewThumbnail.style.hidden = false;
            viewThumbnail.src = currentPost.image
        } else {
            viewThumbnail.style.hidden = true;
        }
    }
}
