
@Component
export struct BingeWatchView {
  @StorageLink("searchBarPosY") searchBarPosY: number = 0;

  build() {
    Column() {
      Flex().height(20)
      Button("偏移-10").onClick(() => {
        this.searchBarPosY -= 10;
      })
      Flex().height(20)
      Button("偏移+10").onClick(() => {
        this.searchBarPosY += 10;
      })
    }
  }
}