<?php

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $response = Http::get('http://flask:5000/');
    return view(
        'welcome',
        [
            'status' => $response->json()['status']
        ]
    );
});
