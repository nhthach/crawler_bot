const Helper = {
    activePage: (page) => {
        document.querySelectorAll('.active[data-page]').forEach((elm) => {
            elm.classList.remove('active');
        });
        setTimeout(() => {
            document.querySelector('[data-page=' + page + ']').classList.add('active');
        }, 0)

    },
    scrollTop: () => {
      window.scroll(0, document.documentElement.getAttribute('scroll-top'))
    },
    isFunction: (obj) => {
        try {
            return typeof obj === 'function';
        } catch (e) {
            return false;
        }
    },
    isAjaxPending: (xhrObject) => {
        return (xhrObject && xhrObject.readyState === 'pending')
    }
}

 export default Helper;