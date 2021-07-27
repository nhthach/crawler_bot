let Services = {}

Services.streamArticles = function (params) {
    return $.ajax({
        type: 'GET',
        data: params,
        url: '/data_stream'
    });
}

Services.streamPost = function (params) {
    return $.get({
        type: 'GET',
        data: params,
        url: "/data_post"
    });
}

export default Services;