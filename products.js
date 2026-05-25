const products = [
  {
    id: 1,
    name: "夢幻粉色大衣",
    price: 1280,
    desc: "帶給你暖呼呼的冬日氛圍，打造慵懶休閒的穿搭",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Polyester 80% / Wool 20%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>40</td>
        <td>96</td>
        <td>105</td>
        <td>58</td>
      </tr>
      <tr>
        <td>M</td>
        <td>42</td>
        <td>100</td>
        <td>110</td>
        <td>59</td>
      </tr>
      <tr>
        <td>L</td>
        <td>44</td>
        <td>104</td>
        <td>115</td>
        <td>60</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L"],
    images: ["images/01.jpg"]
  },
   {
    id: 2,
    name: "百搭基礎牛仔褲",
    price: 960,
    desc: "衣櫃裡一定要有的一條牛仔褲，不挑身材的日常款式",
    detail: `
    <p><strong>材質</strong></p>
    <p>Cotton 98% / Spandex 2%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>褲長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>64</td>
        <td>90</td>
        <td>98</td>
      </tr>
      <tr>
        <td>M</td>
        <td>68</td>
        <td>94</td>
        <td>100</td>
      </tr>
      <tr>
        <td>L</td>
        <td>72</td>
        <td>98</td>
        <td>102</td>
      </tr>
      <tr>
        <td>XL</td>
        <td>76</td>
        <td>102</td>
        <td>104</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],
    images: ["images/02.jpg"]
  },
   {
    id: 3,
    name: "時尚週限定條紋長裙",
    price: 840,
    desc: "時髦剪裁搭配深色條紋，展現精緻氣息",
    detail: `
    <p><strong>材質</strong></p>
    <p>Polyester 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>裙長</th>
      </tr>   
       <tr>
        <td>F</td>
        <td>66</td>
        <td>92</td>
        <td>80</td>
      </tr>
      </table>
  `,
    sizes: ["F"],
    images: ["images/03.jpg"]
  },
    {
    id: 4,
    name: "學院格紋顯身短裙",
    price: 590,
    desc: "經典格紋，甜美的復古學院感",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Polyester 70% / Rayon 30%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>裙長</th>
      </tr>   
       <tr>
        <td>S</td>
        <td>64</td>
        <td>88</td>
        <td>33</td>
      </tr>
      <tr>
        <td>M</td>
        <td>68</td>
        <td>90</td>
        <td>34</td>
      </tr>
      <tr>
        <td>L</td>
        <td>71</td>
        <td>92</td>
        <td>35</td>
      </tr>
      </table>
  `,
    sizes: ["S", "M", "L"],
    images: ["images/04.jpg"]
  },
    {
    id: 5,
    name: "質感牛仔夾克",
    price: 1100,
    desc: "牛仔元素永不過時，顯身材比例的最佳單品",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Cotton 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
     <tr>
        <td>S</td>
        <td>38</td>
        <td>88</td>
        <td>56</td>
        <td>56</td>
      </tr>
      <tr>
        <td>M</td>
        <td>40</td>
        <td>92</td>
        <td>58</td>
        <td>57</td>
      </tr>
      <tr>
        <td>L</td>
        <td>42</td>
        <td>96</td>
        <td>60</td>
        <td>58</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L"],
    images: ["images/05.jpg"]
  },
    {
    id: 6,
    name: "質感黑色牛仔夾克",
    price: 1280,
    desc: "牛仔元素永不過時，顯身材比例的最佳單品",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Cotton 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>38</td>
        <td>88</td>
        <td>56</td>
        <td>56</td>
      </tr>
      <tr>
        <td>M</td>
        <td>40</td>
        <td>92</td>
        <td>58</td>
        <td>57</td>
      </tr>
      <tr>
        <td>L</td>
        <td>42</td>
        <td>96</td>
        <td>60</td>
        <td>58</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L"],
    images: ["images/06.jpg"]
  },
    {
    id: 7,
    name: "紳士透膚襯衫",
    price: 1280,
    desc: "簡約日常的百搭單品",
    detail:   `
    <p><strong>材質</strong></p>
    <p>Polyester 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>38</td>
        <td>88</td>
        <td>56</td>
        <td>56</td>
      </tr>
      <tr>
        <td>M</td>
        <td>40</td>
        <td>92</td>
        <td>58</td>
        <td>57</td>
      </tr>
      <tr>
        <td>L</td>
        <td>42</td>
        <td>96</td>
        <td>60</td>
        <td>58</td>
      </tr>
       <tr>
        <td>XL</td>
        <td>44</td>
        <td>100</td>
        <td>62</td>
        <td>59</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],
    images: ["images/07.jpg"]
  },
    {
    id: 8,
    name: "超前衛運動上衣",
    price: 590,
    desc: "絕不會出錯的T-shirt，本店最熱賣的上衣款式",
    detail:    `
    <p><strong>材質</strong></p>
    <p>Cotton 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
     <tr>
        <td>S</td>
        <td>38</td>
        <td>88</td>
        <td>56</td>
        <td>13</td>
      </tr>
      <tr>
        <td>M</td>
        <td>40</td>
        <td>92</td>
        <td>58</td>
        <td>14</td>
      </tr>
      <tr>
        <td>L</td>
        <td>42</td>
        <td>96</td>
        <td>60</td>
        <td>15</td>
      </tr>
       <tr>
        <td>XL</td>
        <td>44</td>
        <td>100</td>
        <td>62</td>
        <td>16</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],      
    images: ["images/08.jpg"]
  },
    {
    id: 9,
    name: "象牙白打底上衣",
    price: 690,
    desc: "品牌打版T-shirt，簡單但不普通，值得一試的質感上衣",
    detail:   `
    <p><strong>材質</strong></p>
    <p>Cotton 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>38</td>
        <td>88</td>
        <td>56</td>
        <td>13</td>
      </tr>
      <tr>
        <td>M</td>
        <td>40</td>
        <td>92</td>
        <td>58</td>
        <td>14</td>
      </tr>
      <tr>
        <td>L</td>
        <td>42</td>
        <td>96</td>
        <td>60</td>
        <td>15</td>
      </tr>
       <tr>
        <td>XL</td>
        <td>44</td>
        <td>100</td>
        <td>62</td>
        <td>16</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],
    images: ["images/09.jpg"]
  },
    {
    id: 10,
    name: "復古垂感束腳工裝褲",
    price: 690,
    desc: "垂墜感與挺度同時兼具的工裝褲，品牌隱藏的熱賣款",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Polyseter 65% / Cotton 35%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>褲長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>64</td>
        <td>90</td>
        <td>98</td>
      </tr>
      <tr>
        <td>M</td>
        <td>68</td>
        <td>94</td>
        <td>100</td>
      </tr>
      <tr>
        <td>L</td>
        <td>72</td>
        <td>98</td>
        <td>102</td>
      </tr>
      <tr>
        <td>XL</td>
        <td>76</td>
        <td>102</td>
        <td>104</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],
    images: ["images/10.jpg"]
  },
    {
    id: 11,
    name: "男裝天絲彈力直筒卡其褲",
    price: 730,
    desc: "低調百搭的褲型，穿起來舒適度極佳",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Tencel 60% / Cotton 35% / Spandex 5%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>褲長</th>
      </tr>
      <tr>
        <td>S</td>
        <td>64</td>
        <td>90</td>
        <td>98</td>
      </tr>
      <tr>
        <td>M</td>
        <td>68</td>
        <td>94</td>
        <td>100</td>
      </tr>
      <tr>
        <td>L</td>
        <td>72</td>
        <td>98</td>
        <td>102</td>
      </tr>
      <tr>
        <td>XL</td>
        <td>76</td>
        <td>102</td>
        <td>104</td>
      </tr>
    </table>
  `,
    sizes: ["S", "M", "L","XL"],
    images: ["images/11.jpg"]
    },
  
    {
    id: 12,
    name: "亮鑽百褶網紗白色長裙",
    price: 730,
    desc: "充滿亮點的裙裝款式，為穿搭創造華麗的個性",
    detail: `
    <p><strong>材質</strong></p>
    <p>Polyester 100%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>腰圍</th>
        <th>臀圍</th>
        <th>裙長</th>
      </tr>   
       <tr>
        <td>F</td>
        <td>66</td>
        <td>92</td>
        <td>80</td>
      </tr>
      </table>
  `,
    sizes: ["F"],
    images: ["images/12.jpg"]
  },
    {
    id: 13,
    name: "歐美紫色西裝外套",
    price: 1190,
    desc: "穿上自帶氣場的西裝外套，非常時髦的剪裁設計",
    detail:   `
    <p><strong>材質</strong></p>
    <p>Polyester 75% / Rayon 25%</p>

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>F</td>
        <td>42</td>
        <td>94</td>
        <td>60</td>
        <td>58</td>
    </tr>
      </table>
  `,
    sizes: ["F"],
    images: ["images/13.jpg"]
  },
    {
    id: 14,
    name: "斜肩氣質荷葉邊上衣",
    price: 350,
    desc: "除了斜肩也能拉成平口上衣來穿，依照心情自由變換穿法",
    detail:   `
    <p><strong>材質</strong></p>
    <p>Polyester 100%

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>F</td>
        <td>36</td>
        <td>92</td>
        <td>50</td>
        <td>13</td>
    </tr>
      </table>
  `,
    sizes: ["F"],
    images: ["images/14.jpg"]
  },
   {
    id: 15,
    name: "短板聯名渲染上衣",
    price: 440,
    desc: "穿上帶你回到千禧年，渲染設計獨具特色",
    detail:  `
    <p><strong>材質</strong></p>
    <p>Cotton 100%

    <p><strong>尺寸表（cm）</strong></p>
    <table class="size-table">
      <tr>
        <th>Size</th>
        <th>肩寬</th>
        <th>胸圍</th>
        <th>衣長</th>
        <th>袖長</th>
      </tr>
      <tr>
        <td>F</td>
        <td>36</td>
        <td>94</td>
        <td>40</td>
        <td>13</td>
    </tr>
      </table>
  `,
    sizes: ["F"],
    images: ["images/15.jpg"]
  },
];
