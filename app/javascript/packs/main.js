import AppRouter from "spa/routes";
import ArticleController from "packs/article.ctrl";
import PostController from "packs/post.ctrl";
import Helper from "./helper";

class App {
    CrawlingApp = {
        router: new AppRouter(),
        postCtrl: new PostController(),
        articleCtrl: new ArticleController({
            events: {
                onStatusFail: () => {
                    document.getElementById('js-load-more-article').style.display = 'none';
                },
                onMounted: (ins) => {
                    document.getElementById('js-load-more-article')
                        .addEventListener('click', function (){
                        ins.stream();
                    });

                    // Continue load new articles when at the bottom of page
                    window.onscroll = function() {
                        var docElm = document.documentElement;
                        var scrollTop = docElm.scrollTop;
                        var offset = docElm.scrollTop + window.innerHeight;
                        var height = docElm.offsetHeight;
                        if (scrollTop > 0) {
                            docElm.setAttribute('scroll-top', scrollTop);
                        }

                        if (offset >= height) {
                            ins.stream();
                        }
                    };
                },
                onLoading: () => {
                    let loadingButton = document.getElementById('js-load-more-article');
                    loadingButton.classList.add('loading');
                    loadingButton.setAttribute('disabled', 'true');
                    loadingButton.querySelector('span').innerText = 'Processing';
                },
                onLoaded: () => {
                    let loadingButton = document.getElementById('js-load-more-article');
                    loadingButton.classList.remove('loading');
                    loadingButton.removeAttribute('disabled');
                    loadingButton.querySelector('span').innerText = 'Load more';
                },
                onArticleClick: (articleId) => {
                    this.CrawlingApp.router.goto('post?id=' + articleId)
                }
            }
        })
    }

    initAppRoute() {
        this.CrawlingApp.router.createAction('/', (params) => {
            Helper.activePage('article');
            setTimeout(() => { Helper.scrollTop(); }, 10)
            this.CrawlingApp.articleCtrl.mount();
        }, true)

        this.CrawlingApp.router.createAction('post', (params) => {
            Helper.activePage('post');
            this.CrawlingApp.postCtrl.dataSource = this.CrawlingApp.articleCtrl.dataSource;
            this.CrawlingApp.postCtrl.mount(params);
        })

        this.CrawlingApp.router.init();
    }

    start() {
        window.addEventListener('DOMContentLoaded', (event) => {
            this.initAppRoute();
        });

    }
}

export default new App();
