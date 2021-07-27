import Services from "./services";

export default class ArticleController {
    constructor(config) {
        this.dataSource = [];
        this.config = config;
        this.isInitiate = false;
        this.current_page = 0;
        this.next_page = 0;
        this.streamStatus = true;
        this.streamXHRRequest = '';
    }

    mount() {
        if (this.isInitiate) {
            return;
        }
        this.isInitiate = true
        if (typeof this.config.events.onMounted === 'function') {
            this.config.events.onMounted(this);
        }
        this.stream();
    }

    onStatusFail() {
        if (typeof this.config.events.onStatusFail === 'function') {
            this.config.events.onStatusFail()
        }
    }

    onLoading() {
        if (typeof this.config.events.onLoading === 'function') {
            this.config.events.onLoading()
        }
    }

    onLoaded() {
        if (typeof this.config.events.onLoaded === 'function') {
            this.config.events.onLoaded()
        }
    }

    onArticleClick(data) {
        if (typeof this.config.events.onArticleClick === 'function') {
            this.config.events.onArticleClick(data)
        }
    }

    isRequestPending() {
        return (this.streamXHRRequest &&
            this.streamXHRRequest.readyState === 'pending')
    }

    stream() {
        if (!this.streamStatus) {
            return;
        }
        if (this.isRequestPending()) {
            console.log('Pending request! Please wait!');
            return;
        }

        let ref = this;

        ref.onLoading();
        this.streamXHRRequest = Services.streamArticles({page: ref.next_page})
            .then((responseData) => {
                if (responseData['next_page']) {
                    ref.current_page = ref.next_page;
                    ref.next_page += 1;
                } else {
                    ref.streamStatus = false;
                    ref.onStatusFail();
                    return
                }
                ref.dataSource = ref.dataSource.concat(responseData['articles']);
                ref.render(responseData['articles']);
                ref.onLoaded();
            }).catch((e) => {
                ref.streamStatus = false;
                ref.onStatusFail();
                ref.onLoaded();
            })
    }

    render(data) {
        let ref = this;
        let articlesRoot = document.getElementsByTagName('article-list')[0];

        data.forEach((article) => {
            articlesRoot.insertAdjacentHTML("beforeend", this.template(article));
        });

        let elms = document.getElementsByClassName('article-item');
        for (let i=0;i<elms.length;i++) {
            elms[i].addEventListener('click', function () {
                ref.onArticleClick(this.getAttribute('data-article-id'));
                elms[i].classList.remove('article-item');
            })
        }

    }

    template(data) {
        return `
            <div class="item rounded border-indigo-50 border px-3 py-2">
                <div class="item-header sm:text-left sm:flex-grow">
                    <div class="title text-left">
                        <a class="cursor-pointer font-semibold article-item" data-article-id="${data.id}">${data.title}</a>
                    </div>
                    
                    <div class="source flex flex-row justify-between">
                      <span class="text-left source text-xs text-gray-500">${data.source_name}</span>
                      <span class="text-right source text-xs text-gray-500">${data.author}</span>
                    </div>
                </div>
                
                 <div class="item-img my-2 text-center h-48 w-full">
                    <img class="rounded inline-block h-full w-full" src="${data.image}" />
                </div>
                
                <div class="item-desc">
                    <p class="text-sm text-grey-dark text-center text-gray-500">${data.short_content}</p>
                </div>
            </div>
        `
    }
}
