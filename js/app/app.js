$(document).ready(function() {
    $('.burger').click(function(){
        $(this).toggleClass('burgerCross');
    });
    $('.burger').click(function() {
        if ($('.burger').hasClass('burgerCross')) {
            $('nav').addClass('nav--open');
            $('.line1').addClass('lineStatic');
            $('.line3').addClass('lineStatic');
        }
        else {
        $('nav').removeClass('nav--open');
        $('.line1').removeClass('lineStatic');
        $('.line3').removeClass('lineStatic');
        }
    });
    $('.nav li a').click(function() {
        if ($('.burger').hasClass('burger')) {
            $('.burger').removeClass('burger');
            $('nav').removeClass('nav--open');
        }
    });
});
