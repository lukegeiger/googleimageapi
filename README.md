# Google Image Search API (Deprecated)

<p align="center">
  <img src="https://raw.githubusercontent.com/lukegeiger/googleimageapi/master/1.png">
  <img src="https://raw.githubusercontent.com/lukegeiger/googleimageapi/master/2.png">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/lukegeiger/googleimageapi/master/3.png">
  <img src="https://raw.githubusercontent.com/lukegeiger/googleimageapi/master/4.png">
</p>

# Overview & Goals

The purpose of this project was to use the deprecated Google Image Search API, found [here](https://developers.google.com/image-search/). Below are the goals.

- 3 images in a row using a UIScrollView.
- Save search history.
- Incremental loading when a user scrolls to the bottom of the page.

# APIs

I created a Singleton wrapper that fetches photos from the API, below is a sample of how it works.

```objective-c

    [[GImageAPI sharedAPI]fetchPhotosForQuery:search.query shouldPage:YES onCompletion:^(NSArray*gimages,NSError*error){
        
    }];
}
```

# Possible Improvements

- Stop using the Deprecated API.
- Rework the GImageAPI singleton.
- Empty data sets images.
