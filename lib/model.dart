List<Person> people = [
  Person(
    name: "John Snow",
    country: "Iceland",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    followers: 13000,
    images: 2000,
    posts: 3000,
    profileImage: "assets/img_1.jpg",
    imagesList: [
      "assets/img_1.jpg",
      "assets/img_1_1.jpg",
      "assets/img_1_2.jpg",
    ],
    isFollowing: false,
  ),
  Person(
    name: "Tyrion Lannister",
    country: "Switzerland",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    followers: 256000,
    images: 39000,
    posts: 31000,
    profileImage: "assets/img_2.jpg",
    imagesList: [
      "assets/img_2.jpg",
      "assets/img_2_1.jpg",
      "assets/img_2_2.jpg",
    ],
    isFollowing: false,
  ),
  Person(
    name: "Eddard Stark",
    country: "Norway",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    followers: 68000,
    images: 19000,
    posts: 5000,
    profileImage: "assets/img_3.jpg",
    imagesList: [
      "assets/img_3.jpg",
      "assets/img_3_1.jpg",
      "assets/img_3_2.jpg",
    ],
    isFollowing: false,
  ),
];

class Person {
  final String name;
  final String country;
  final String description;
  final int followers;
  final int images;
  final int posts;
  final String profileImage;
  final List<String> imagesList;
  bool isFollowing;

  Person({
    this.name,
    this.country,
    this.description,
    this.followers,
    this.images,
    this.posts,
    this.profileImage,
    this.imagesList,
    this.isFollowing,
  });
}
