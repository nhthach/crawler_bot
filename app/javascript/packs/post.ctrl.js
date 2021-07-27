import Services from "./services";
import Helper from "./helper";

export default class PostController {
    constructor(config) {
        this.config = config;
        this.streamXHRRequest = null;
        this.postID = null;
        this.dataSource = [];
        this.isInitiate = false;
    }

    mount (params) {
        this.postID = params['id'];
        this.view();
        // if(this.isInitiate) {
        //
        // } if (!this.isInitiate && this.dataSource.length === 0) {
        //     this.stream();
        //     this.isInitiate = true;
        // }
    }

    view() {

        let ref = this;
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

    stream() {
        let ref = this;
        this.streamXHRRequest = Services.streamPost({id: this.postID})
            .then((responseData) => {
                ref.dataSource = [{
                    id: ref.postID,
                    link: 'https://google.com'
                }]
                ref.view();
            }).catch((e) => {
                ref.dataSource = [{
                    id: ref.postID,
                    link: 'https://google.com'
                }]
                ref.view();
            })
    }
}
